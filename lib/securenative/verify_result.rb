# frozen_string_literal: true

module SecureNative
  class VerifyResult
    attr_reader :risk_level, :score, :triggers
    attr_writer :risk_level, :score, :triggers

    def initialize(risk_level: nil, score: nil, triggers: nil)
      @risk_level = risk_level
      @score = score
      @triggers = triggers
    end

    def to_s
      "risk_level: #{@risk_level}, score: #{@score}, triggers: #{@triggers}"
    end
  end
end
