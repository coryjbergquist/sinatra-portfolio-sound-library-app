
class Sound < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :description, :filename

  def slug
    @slug = self.name.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    self.name = @slug
  end

def self.find_by_slug(slug)
  new_slug = slug.gsub("-", " ").split(/ |\_/)
  new_slug = new_slug.join(" ")
  self.find_by(name: new_slug)
end

def include_chars?(subject, characters)
  characters.chars.each { |char| subject.include?(char) }
end

end
