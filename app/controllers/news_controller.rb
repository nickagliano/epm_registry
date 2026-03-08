class NewsController < ApplicationController
  POSTS_ROOT = Rails.root.join("posts")

  def index
    @posts = load_all_posts.sort_by { |p| p[:date] }.reverse
  end

  def show
    slug = params[:slug]
    raise ActionController::RoutingError, "Not found" unless slug.match?(/\A[a-z0-9\-]+\z/)

    file = POSTS_ROOT.glob("*-#{slug}.md").first
    raise ActionController::RoutingError, "Not found" unless file&.exist?

    @post = parse_post(file)
  end

  private

  def load_all_posts
    POSTS_ROOT.glob("*.md").map { |f| parse_post(f) }
  end

  def parse_post(file)
    raw = file.read
    frontmatter, body = extract_frontmatter(raw)
    slug = file.basename(".md").to_s.sub(/\A\d{4}-\d{2}-\d{2}-/, "")
    {
      slug: slug,
      title: frontmatter["title"] || slug.tr("-", " ").capitalize,
      date: parse_date(frontmatter["date"], file),
      body_html: render_markdown(body)
    }
  end

  def extract_frontmatter(raw)
    if raw.start_with?("---")
      parts = raw.split("---", 3)
      fm = parts[1].lines.each_with_object({}) do |line, h|
        k, v = line.split(":", 2)
        h[k.strip] = v&.strip if k
      end
      [ fm, parts[2].to_s.strip ]
    else
      [ {}, raw.strip ]
    end
  end

  def parse_date(frontmatter_date, file)
    Date.parse(frontmatter_date.to_s)
  rescue ArgumentError, TypeError
    begin
      Date.parse(file.basename.to_s[0..9])
    rescue ArgumentError
      Date.today
    end
  end

  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: false)
    Redcarpet::Markdown.new(renderer,
      fenced_code_blocks: true, tables: true, autolink: true, strikethrough: true
    ).render(text).html_safe
  end
end
