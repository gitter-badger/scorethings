class Thing
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :full_url, type: String
  field :pageid, type: Integer
  field :image_urls, type: Array
  field :title, type: String


  has_many :scores, autosave: true, dependent: :delete
  has_and_belongs_to_many :thing_categories, autosave: true

  index({ pageid: 1 }, { unique: true, name: 'thing_pageid_index' })

  token :contains => :fixed_numeric, :length => 8

  search_in :title, :thing_categories => [:title]

  validates_presence_of :full_url, :pageid, :title

  def self.build_from_wikipedia_page_info(info)
    Thing.new(pageid: info[:pageid], full_url: info[:full_url], title: info[:title], image_urls: info[:image_urls] || [])
  end
end
