
class Sound < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :description, :filename
  validates_uniqueness_of :name, scope: :user_id
  validates_uniqueness_of :filename
  validates_format_of :name, with: /\A[A-Za-z0-9]*\z/, message: "Don't use special characters in the sound name! You'll break everything!"
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

  def file=(file_hash)
    filename = file_hash[:filename]
    file = file_hash[:tempfile]
    File.open("./public/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    self.filename = filename
  end

end
