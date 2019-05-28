module Configurations
  def configurations
    # Non è possibile criptare i report se si vuole prevedere di inserire del testo durante l'annullamento

    #encrypt_document(
    #  :user_password  => Settings.reportpasswdforopen,
    #  :owner_password => :random,
    #  :permissions => {
    #    :print_document     => true,
    #    :modify_contents    => false,
    #    :copy_contents      => false,
    #    :modify_annotations => false
    #  }
    #)

    font_families.update("OpenSans" => {
      :normal => Rails.root.join('app', 'assets', 'images', 'OpenSans-Regular.ttf'),
      :bold => Rails.root.join('app', 'assets', 'images', 'OpenSans-Bold.ttf'),
    })

    @cell_border_color = '000000'
    @fontsize = 9
    @fontsize_footer = @fontsize - 2
    @fontsize_table = @fontsize - 2
    @t_height = 0
    @footer_height = 80
    @max_rows = 20
  end
end