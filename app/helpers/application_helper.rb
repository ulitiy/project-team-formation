module ApplicationHelper

  def title(page_title)
    content_for(:title,page_title.to_s)
  end

  def head(str)
    content_for :head, str
  end

end

