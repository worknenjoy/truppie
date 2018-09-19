class WelcomeController < ApplicationController
  include ApplicationHelper

  def change_locale
    l = params[:locale].to_s.strip.to_sym
    l = I18n.default_locale unless I18n.available_locales.include?(l)
    cookies.permanent[:my_locale] = l
    redirect_to request.referer || root_url
  end

  def index
    @tours = Tour.publisheds
    @next_tour = Tour.recents.first
    @next_tours = Tour.publisheds.nexts
    @past_tours = Tour.publisheds.past
    @organizers = Organizer.publisheds.order(created_at: :asc)
    @guidebooks = Guidebook.publisheds
    @wheres = Where.last(4).reverse
  end

  def organizer
    if current_user
      @organizer = Organizer.find_by(user_id: current_user.id)
      if @organizer
        redirect_to profile_edit_organizer_path(@organizer)
      else
        @new_organizer = Organizer.new
      end
    else
      if !@new_organizer
        @new_organizer = Organizer.new
      end
    end
  end

  def user
    @backgrounds = Background.all
  end

  def logos

  end

  def manifest
    locale = I18n.locale || params[:locale].to_s
    @page = AdminPage.where(lang: locale, namespace: 'manifest').first
  end

  def how_it_works
    locale = I18n.locale || params[:locale].to_s
    @page = AdminPage.where(lang: locale, namespace: 'how_it_works').first
  end

  def privacy
    locale = I18n.locale || params[:locale].to_s
    @page = AdminPage.where(lang: locale, namespace: 'privacy').first
  end

  def defs

  end

  def faq
    locale = I18n.locale || params[:locale].to_s
    @page = AdminPage.where(lang: locale, namespace: 'faq').first
  end

end
