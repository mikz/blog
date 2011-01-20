# coding: UTF-8
[
  ["Markdown", "RDiscount", "to_html"],
  ["Textile",  "RedCloth",  "to_html"]
].each do |row|
  Format.create :name => row[0], :class_name => row[1], :method => row[2]
end
