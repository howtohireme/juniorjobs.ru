# frozen_string_literal: true

module Admin
  # Controller for handling jobs in admin namespace.
  class JobsController < BaseController
    before_action :load_job, except: %i[index]

    def index
      @jobs = Job.order(:status)
    end

    def edit; end

    def update
      if @job.update(job_params)
        redirect_to admin_jobs_path, notice: t('common.jobs.update.success')
      else
        redirect_to edit_admin_job_path(@job), alert: t('common.jobs.create.fail', @job.errors.messages.first)
      end
    end

    def destroy
      @job.destroy
      redirect_to admin_jobs_path, notice: t('admin.jobs.destroy.success')
    end

    def aproove
      if @job.aproove!
        redirect_to admin_jobs_path, notice: t('admin.jobs.aproove.success')
      else
        redirect_to admin_jobs_path, alert: t('admin.jobs.aproove.fail')
      end
    end

    def unaproove
      if @job.unaproove!
        redirect_to admin_jobs_path, notice: t('admin.jobs.unaproove.success')
      else
        redirect_to admin_jobs_path, alert: t('admin.jobs.unaproove.fail')
      end
    end

    private

    def load_job
      @job = Job.find(params[:id])
    end

    def job_params
      params.require(:job).permit(
        :id, :status,
        :title, :description,
        :requirements, :employment,
        :city, :country, :remote,
        :currency, :salary_from, :salary_to, :salary_by_agreement,
        :company_contact, :company_email, :company_name, :company_page, :company_phone,
        :expired_at,
        :token
      )
    end
  end
end