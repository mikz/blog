class EnkiFormatter
  class << self
    def format_as_xhtml(text, format = nil)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda {|text| format.present? ? format.process(text) : text },
        :code_formatter => Lesstile::CodeRayFormatter
      )
    end
  end
end
