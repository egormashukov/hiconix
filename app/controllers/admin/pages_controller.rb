class Admin::PagesController < Admin::ApplicationController
  before_action :set_page, only: [:edit, :update, :destroy ]
  before_action :authorize_page
  helper_method :apply_redirect

  def index
    @pages = policy_scope(Page).order(:created_at)
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      notice = "#{Page.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @page_blocks = @page.page_blocks.by_position
  end

  def update
    if @page.update(page_params)
      notice = "#{Page.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @page.destroy
    redirect_to [:admin, :pages], notice: "#{Page.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @page], notice: notice
      else
        redirect_to [:admin, :pages], notice: notice
      end
    end

    def authorize_page
      authorize :page, :user_has_rights?
    end

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :slug, :local_menu, :local_menu_position, :body, :metadesc, :metakeywords, :seo_title, :print_link)
    end
end