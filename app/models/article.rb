class Article < ApplicationRecord

  has_many :photos

  def self.tabs
    [
      ["필름", "films"],
      ["포토", "photos"],
      ["견적", "pricing"]
    ]
  end

  def self.categories
    { 
      "필름": [
        ["카본", "carbon"],
        ["우드", "wood"],
        ["기타", "etc"]
      ],
      "포토": [
        ["국산차", "domestic"],
        ["수입차", "imported"]
      ],
      pricing: [
        ["경차", "compact"],
        ["중형차", "midsize"],
        ["대형차", "fullsize"],
        ["수입차", "imported"]
      ]
    }
  end

  def category_name
    {
      "films": "필름",
      "photos": "포토",
      "pricing": "견적",
      "carbon": "카본",
      "wood": "우드",
      "etc": "기타",
      "domestic": "국산차",
      "imported": "수입차",
      "compact": "경차",
      "midsize": "중형차",
      "fullsize": "대형차"
    }[self.category.to_sym]
  end

  def tab_name
    {
      "films": "필름",
      "photos": "포토",
      "pricing": "견적",
      "carbon": "카본",
      "wood": "우드",
      "etc": "기타",
      "domestic": "국산차",
      "imported": "수입차",
      "compact": "경차",
      "midsize": "중형차",
      "fullsize": "대형차"
    }[self.tab.to_sym]
  end

end
