# frozen_string_literal: true

module Web
  # This class adds possibility to add and handle Curriculum Vitae
  class CvsController < BaseController
    before_action :require_login, :check_junior, except: %i[index show]
    before_action :load_cv, only: %i[show edit update destroy]

    def index
      @cvs = get_sorted_cvs Cv.where(status: true)
    end

    def own
      @cvs = get_sorted_cvs current_user.cvs
      authorize Cv
    end

    def show; end

    def new
      @cv = current_user.cvs.build.decorate
      authorize @cv
    end

    def create
      @cv = current_user.cvs.create(cv_params)
      authorize @cv
      if @cv.save
        redirect_to cv_path(@cv), notice: t('common.cvs.create.success')
      else
        render :new, alert: t('common.cvs.create.fail')
      end
    end

    def edit; end

    def update
      if @cv.update(cv_params)
        redirect_to cv_path(@cv), notice: t('common.cvs.update.success')
      else
        error_msg = @cv.errors.messages[:description].first
        redirect_to edit_cv_path(@cv), alert: t('common.cvs.create.fail', error: error_msg)
      end
    end

    def destroy
      if @cv.destroy
        redirect_to cvs_path, notice: t('common.cvs.delete.success')
      else
        error_msg = @cv.errors.messages[:description].first
        redirect_back fallback_location: root_path, alert: t('common.cvs.delete.fail', error: error_msg)
      end
    end

    private

    def load_cv
      @cv = Cv.find(params[:id]).decorate
      authorize @cv
    end

    def get_sorted_cvs(collection)
      collection.order(updated_at: :desc).page(params[:page]).per(10)
    end

    def cv_params
      params.require(:cv).permit(
        :id, :status,
        :title, :employment,
        :name, :description,
        :country, :city,
        :remote, :currency,
        :salary_from, :salary_to, :salary_by_agreement,
        :education, :skills, :work_experience,
        :expired_at,
        :address, :phone, :email, :web_site
      )
    end

    def check_junior
      return if current_user.role?(:junior) || current_user.role?(:admin)
      render plain: t('admin.base.check_admin.permission_denied'), status: :forbidden
    end
  end
end
