require 'ddduel'

class TxManager
  def transaction
    puts 'tx: begin'
    yield
  ensure
    puts 'tx: end'
  end
end

class VideoUpdatedEvent < DDDuel::Event
end

class VideoNotFound < StandardError
end

# in actuality this would be the activerecord model class.
class Video
  include DDDuel::AggregateRoot

	attr_reader :id
  attr_reader :title

  def initialize(id: , title: nil)
    @id = id
    @title = title
  end

	def updateTitle(new_title)
		puts "updating title to '#{new_title}'"
		title = new_title
  ensure
    ddd_record_event VideoUpdatedEvent.new(
      aggregate_id: self.id
    )
	end

	def save
		puts "dbal: save"
	end

	private

	attr_writer :title
end

class Video_AR__RELATION
  def model = Video
	def self.all
		return new()
	end

	def find(id)
		Video.new(id: id)
	end
end

class VideoRepository < DDDuel::Repository
	def initialize(relation: nil)
		super(relation: relation || Video_AR__RELATION.all)
	end

	def find(id)
		puts "searching video '#{id}'"
		@relation.find(id)
	end

	def save(aggregate)
		aggregate.save
  end
end

class UpdateVideoRequest < DDDuel::UseCase::Request
	attr_reader :id, :title
end

class FindVideoRequest < DDDuel::UseCase::Request
  attr_reader :id, :title
end

class FindVideoUseCase < DDDuel::UseCase
  def initialize(video_repository: )
    @video_repository = video_repository
  end

  def execute!(request)
    puts "running: #{self.class}"
    video = @video_repository.find(request.id)
    raise VideoNotFound.new unless video
    video
  end
end

class UpdateVideoTitleUseCase < DDDuel::UseCase
	def initialize(video_repository: , video_finder: )
		@video_repository = video_repository
    @video_finder = video_finder
	end

	def execute!(request)
		puts "running: #{self.class}"
    video = @video_finder.call(FindVideoRequest.new(id: request.id))
    video.updateTitle(request.title)
    @video_repository.save(video)
    video
  end
end


video_repo = VideoRepository.new()
update_req = UpdateVideoRequest.new(id: 1, title: 'new_title')

find_use_case = FindVideoUseCase.new(video_repository: video_repo)

use_case = UpdateVideoTitleUseCase.new(video_repository: video_repo, video_finder: find_use_case)

video = use_case.call(update_req)
pp(video.ddd_delete_domain_events!)

puts
puts '--'
puts

tx1_use_case = DDDuel::TxWrapper.new(
	tx_manager: TxManager.new.method(:transaction),
	use_case: use_case
)

video = tx1_use_case.call(update_req)
pp(video.ddd_delete_domain_events!)



# da rails tie
DynTxWrapper = Class.new(DDDuel::TxWrapper) do
  def initialize(**kawgs)
    super(**kawgs, tx_manager: TxManager.method(:transaction))
  end
end

tx1_use_case = DynTxWrapper.new(
  use_case: use_case
)
