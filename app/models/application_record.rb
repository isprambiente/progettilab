class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def row
    return ['tr_', self.class.to_s.gsub('::', '_'), '_', id].join.downcase
  end

  def create_log
    author = 'System' if author.blank?
    action = ''
    field = ''
    if new_record?
      action = 'create' unless action.present?
    elsif changed?
      field = changes
      action = 'update' unless action.present?
    elsif destroyed?
      action = 'delete' unless action.present?
    end
    log_body = try(:log_body) || ''
    justification = I18n.t( 'action', scope: ["#{self.class.try(:to_s).try(:downcase).try(:pluralize) unless self.class.blank? }", action].reject(&:empty?).join('.'), default: "#{action} #{self.class.try(:to_s).try(:downcase).try(:pluralize) unless self.class.blank?} ", :locale => :it ) + ' ' + "#{try(:code)}".to_s unless justification.present?
    justification += " - Cambiamento: #{ changes }" unless justification.present? if action == 'update'
    justification += " - Motivo riapertura: #{  log_body }" unless log_body.blank?
    self.logs_attributes = [ { job: try(:job), author: author, action: action, body: justification, field: field } ] unless action.blank?
  end
end