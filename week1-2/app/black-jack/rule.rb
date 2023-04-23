# frozen_string_literal: true

# ブラックジャックのルールを表現したクラス
class Rule
  def burst?(total_score)
    total_score > 21
  end

  def stand?(total_score)
    total_score >= 17
  end
end
