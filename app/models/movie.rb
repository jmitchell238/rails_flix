class Movie < ApplicationRecord

  before_save :set_slug

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_one_attached :main_image

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  
  RATINGS = %w(G PG PG-13 R NC-17).freeze
  validates :rating, inclusion: { in: RATINGS }

  validate :acceptable_image

  scope :released, -> { where('released_on < ?', Time.now).order('released_on desc') }
  scope :upcoming, -> { where('released_on > ?', Time.now).order('released_on asc') }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :hits, -> { released.where('total_gross >= 300000000').order(total_gross: :desc) }
  scope :flops, -> { released.where('total_gross < 225000000').order(total_gross: :asc) }
  scope :grossed_less_than, ->(amount) { released.where('total_gross < ?', amount) }
  scope :grossed_greater_than, ->(amount) { released.where('total_gross > ?', amount) }

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end

  def average_stars_as_percent
    (self.average_stars / 5.0) * 100.0
  end

  def to_param
    slug
  end

  private
  def acceptable_image
    return unless main_image.attached?

    unless main_image.blob.byte_size <= 1.megabyte
      errors.add(:main_image, 'is to big')
    end

    acceptable_types = ['image/jpeg', 'image/png']
    unless acceptable_types.include?(main_image.content_type)
      errors.add(:main_image, 'must be a JPEG or PNG')
    end

  end

  def set_slug
    self.slug = title.parameterize
  end

end
