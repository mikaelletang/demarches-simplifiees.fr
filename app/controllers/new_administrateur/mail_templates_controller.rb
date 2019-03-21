module NewAdministrateur
  class MailTemplatesController < AdministrateurController
    include ActionView::Helpers::SanitizeHelper
    
    def edit
      @procedure = procedure
      @mail_template = find_mail_template_by_slug(params[:id])
    end

    def update
      @procedure = procedure
      mail_template = find_mail_template_by_slug(params[:id])
      mail_template.update(update_params)
      redirect_to admin_procedure_mail_templates_path
    end

    def preview
      @procedure = procedure
      @logo_url = procedure.logo.url
      @service = procedure.service

      mail_template = find_mail_template_by_slug(params[:id])

      render(html: sanitize(mail_template.body), layout: 'mailers/notification')
    end

    private

    def procedure
      @procedure = current_administrateur.procedures.find(params[:procedure_id])
    end

    def mail_templates
      [
        @procedure.initiated_mail_template,
        @procedure.received_mail_template,
        @procedure.closed_mail_template,
        @procedure.refused_mail_template,
        @procedure.without_continuation_mail_template
      ]
    end

    def find_mail_template_by_slug(slug)
      mail_templates.find { |template| template.class.const_get(:SLUG) == slug }
    end

    def update_params
      {
        procedure_id: params[:procedure_id],
        subject: params[:mail_template][:subject],
        body: params[:mail_template][:body]
      }
    end
  end
end
