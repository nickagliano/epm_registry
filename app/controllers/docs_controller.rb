class DocsController < ApplicationController
  DOCS_ROOT = Rails.root.join("docs")

  SIDEBAR = [
    {
      title: "Concepts",
      pages: [
        { title: "What is EPS?",      path: "concepts/what-is-eps" },
        { title: "Ports",             path: "concepts/ports" },
        { title: "CUSTOMIZE.md",      path: "concepts/customize-md" }
      ]
    },
    {
      title: "Architecture Decisions",
      pages: [
        { title: "ADR-0001 — Implementation Languages",   path: "adr/0001-rust-primary-language" },
        { title: "ADR-0002 — Centralized Registry",       path: "adr/0002-centralized-registry" },
        { title: "ADR-0003 — eps.toml Manifest Format",   path: "adr/0003-eps-manifest-format" },
        { title: "ADR-0004 — CLI Named epm",              path: "adr/0004-cli-named-epm" },
        { title: "ADR-0005 — LLM-Friendliness",           path: "adr/0005-llm-friendliness" },
        { title: "ADR-0006 — EPS Acceptance Standards",   path: "adr/0006-eps-acceptance-standards" },
        { title: "ADR-0007 — Licensing Philosophy",       path: "adr/0007-licensing-philosophy" },
        { title: "ADR-0008 — The Harness Definition",     path: "adr/0008-harness-definition" },
        { title: "ADR-0009 — Install Lifecycle",          path: "adr/0009-install-lifecycle" },
        { title: "ADR-0010 — Registry Auth & Namespacing", path: "adr/0010-registry-auth-and-namespacing" },
        { title: "ADR-0011 — Supply Chain Security",      path: "adr/0011-supply-chain-security" },
        { title: "ADR-0012 — Documentation Format",       path: "adr/0012-mdbook-documentation" },
        { title: "ADR-0013 — System Dependencies",        path: "adr/0013-system-dependency-declaration" },
        { title: "ADR-0014 — epm init Scaffolding",       path: "adr/0014-epm-init-scaffolding" }
      ]
    }
  ].freeze

  def show
    slug = params[:path] || "concepts/what-is-eps"
    file = DOCS_ROOT.join("#{slug}.md")

    unless file.to_s.start_with?(DOCS_ROOT.to_s) && file.exist?
      raise ActionController::RoutingError, "Doc not found: #{slug}"
    end

    @content_html = render_markdown(file.read)
    @sidebar = SIDEBAR
    @current_path = slug
    @title = extract_title(@content_html)
  end

  private

  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: false,
      with_toc_data: true,
      link_attributes: { target: "_blank", rel: "noopener" }
    )
    md = Redcarpet::Markdown.new(renderer,
      fenced_code_blocks: true,
      tables: true,
      autolink: true,
      strikethrough: true,
      highlight: true,
    )
    md.render(text).html_safe
  end

  def extract_title(html)
    html.match(/<h1[^>]*>(.*?)<\/h1>/m)&.captures&.first&.gsub(/<[^>]+>/, "") || "Docs"
  end
end
