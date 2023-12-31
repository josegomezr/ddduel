DDD from Rails
==============

Implementing pure DDD in your rails app is to put it midly a very unrealistic
goal.

Your rails application is modeled after MVC architecture.

[graph with MVC]

They seem to be isolated from each other and hooked all together via the global
rails application object.

But by "convenience" (for lack of a better word) Rails provides you ways to jump
between layers constantly. This is not to say that one pattern is better than
the other, but rather to state that these jumps *will* make your journey to
isolate components **much harder**.

What usually ends up with these "conveniences" is that:

- Controllers:

    * They're guaranteed to grow in code. There's the concept of "Concerns"
      which you can use to shove methods in another module and load them so the
      controller "looks small" (that's the intended purpose of concerns).

    * They're guaranteed to grow in responsabilities. Controllers would not only
      handle IO (Request-Response lifecycle)
    
    * Content Negotiation can get complex in itself. There's no standard or good
      example on how to do this other than:

      ```ruby
      # [...]
      responds.to do |format|
        format.csv { ... }
        format.html { ... }
        format.json { ... }
        format.xml { ... }
      end
      # [...]
      ```

- Models
    
    * Models usually keep DBAL persistence logic. It's common to see:

        ```ruby
        def update_title!(new_title)
            update!(title: new_title) # DBAL action inside business logic
        end
        ```

- Models & Controllers:  
Either:
    * Controllers will hold all the I/O + business logic + Repository + DBAL logic:

        ```ruby
        # model
        class Model < ActiveRecord::Base
        end

        # controller
        class ModelsController
            def update
                # I/O (Request-Response lifecycle)
                model_id, model_title = params.values_at(:id, :title)

                model_obj = Model.find_by(params_id) # repository
                model_obj.title = params_title # actual business logic
                model_obj.save! # DBAL logic

                redirect_to done_path # I/O (Request-Response lifecycle)
            end
        end
        ```

    * Model will hold DBAL + Repository logic, controller holds I/O + business logic (this tends to be the sanest, but it grows *quickly* in complexity:

        ```ruby
        # model
        class Model < ActiveRecord::Base
            def update_title!(new_title)
                update!(title: new_title) # DBAL logic
            end
        end

        # controller
        class ModelsController
            def update
                # I/O (Request-Response lifecycle)
                model_id, model_title = params.values_at(:id, :title)

                model_obj = Model.find_by(params_id) # repository
                model_obj.update_title!(params_title) # business logic

                redirect_to done_path # I/O (Request-Response lifecycle)
            end
        end
        ```

- Views:

    * Views look "isolated" from afar, but they're coupled to the controller
      they're being rendered from. It has access to the `@`-vars from it.

      ```ruby
        class Model < ActiveRecord::Base
        end

        class ModelsController
            def index
                @records = Model.all # this is lazily eval.
            end
        end
      ```

      in the view:

      ```html
      <% @records.each do |record| %> <!-- here: side effect -->
        - <%= record.title %>
      <% end %>
      ```

    * It's *quite common* to pass models to views, and this is **the main source
      of accidental N+1's behavior**. Full `ActiveRecord::Model` instances in
      views **will** eventually lead to accidental side effects.

      ```ruby
        class Model < ActiveRecord::Base
            scope :only_blue, -> { where(color: :blue) }
            scope :not_blue, -> { where.not(color: :blue) }
        end

        class ModelsController
            def index
                @records = Model.all # this is lazily eval.
            end
        end
      ```

      in the view:

      ```html
      Blue Records:
      <% @records.only_blue.each do |record| %> <!-- here: side effect -->
        - <%= record.title %>
      <% end %>

      Other Records:
      <% @records.not_blue.each do |record| %> <!-- here: side effect -->
        - <%= record.title %>
      <% end %>
      ```

      When the code base grows more, these side effects are harder to spot.
