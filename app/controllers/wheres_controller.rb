class WheresController < ApplicationController
  def index
    @wheres = Where.all
  end
end
