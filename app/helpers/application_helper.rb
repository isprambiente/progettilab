module ApplicationHelper
  def content_class
    l = 12
    l -= 1 if content_for :left
    l -= 1 if content_for :right
    m = 12
    m -= 1 if content_for :left
    m -= 1 if content_for :right
    return "large-#{l} medium-#{m} cell"
  end

  def translate(value, scope: '')
    I18n.t(value, scope: scope, default: value)
  end

  def flash_box
    "#{alert_box(flash[:alert], 'alert') if flash[:alert].present?}
     #{alert_box(flash[:notice], 'success') if flash[:notice].present?}".html_safe
  end

  def alert_box(message, style = 'primary')
    "<div class='#{style} callout' data-closable>#{message}
    <button class='close-button' aria-label='Dismiss alert' type='button' data-close><span aria-hidden='true'>&times;</span></button>
    </div>"
  end

  def icon(file)
    case file.file_content_type.to_s
      when 'image/jpeg'
        return 'file-image-o'
      when 'image/png'
        return 'file-image-o'
      when 'image/gif'
        return 'file-image-o'
      when 'image/bmp'
        return 'file-image-o'
      when 'image/tiff'
        return 'file-image-o'
      when 'image/x-icon'
        return 'file-image-o'
      when 'text/plain'
        return 'file-text-o'
      when 'text/html'
        return 'file-code-o'
      when 'text/csv'
        return 'file-excel-o'
      when 'application/msword'
        return 'file-word-o'
      when 'application/pdf'
        return 'file-pdf-o'
      when 'application/vnd.ms-excel'
        return 'file-excel-o'
      when 'application/vnd.ms-powerpoint'
        return 'file-powerpoint-o'
      when 'application/zip'
        return 'file-archive-o'
      when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        return 'file-excel-o'
      when 'pplication/vnd.openxmlformats-officedocument.presentationml.presentation'
        return 'file-powerpoint-o'
      when 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        return 'file-word-o'
      else
        return 'file'
    end
  end

  def nav_tab( controller: '', action: '', section: '', page: '' )
    tab = ''
    selected = section
    if controller == 'jobs'
      tab = 'jobs'
      if action == 'analisies'
        tab = 'analisies'
        selected = 'analisies'
      elsif action == 'logs'
        tab = 'logs'
      elsif action == 'reports'
        tab = 'reports'
      end
    elsif controller == 'timetables'
      tab = 'timetables'
    elsif controller == 'samples'
      tab = 'samples'
      if action == 'new'
        selected = 'new'
      elsif action == 'index'
        selected = 'index'
      end
    elsif controller == 'analisies'
      tab = 'analisies'
    elsif controller == 'reports'
      tab = 'reports'
    elsif controller == 'import'
      selected = 'import'
      tab = 'analisies'
    end
    if action == 'attachments'
      selected = 'attachments'
    end
    return tab, selected
  end

end