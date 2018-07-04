class Photo < ApplicationRecord

  store :filesize, coder: JSON
  store :dimensions, accessors: [:original, :thumb, :edited], coder: JSON
  store :positions, accessors: [:left, :top], coder: JSON
  store :details, accessors: [:ratio, :type, :frames, :mime_type, :shape], coder: JSON
  store :colors,  accessors: [:hex, :rgb, :hsv], coder: JSON

  before_destroy :destroy_assets

  def title
    self.original_filename
  end

  # dimensions
  def thumb
    if self.frames.to_i > 1
      self.dimensions["original"]
    else
      self.dimensions["edited"].present? ? self.dimensions["edited"] : super
    end
  end

  def url(style = :thumb)
    if self.frames.to_i > 1
      style = :original
    elsif style == :thumb && File.exist?(self.path(:edited))
      style = :edited
    end
    "/system/photos/#{self.created_at_to_path}/#{style.to_s}_#{self.filename}"
  end

  def path(style = nil)
    dir = "#{Rails.root.to_s}/public/system/photos/#{self.created_at_to_path}"
    FileUtils.mkdir_p dir

    if style.blank?
      dir
    else
      if self.frames.to_i > 1
        style = :original
      elsif style == :thumb && File.exist?("#{dir}/edited_#{self.filename}")
        style = :edited
      end
      "#{dir}/#{style.to_s}_#{self.filename}"
    end
  end

  def hashkey
    if self.read_attribute(:hashkey).blank?
      self.hashkey = Digest::MD5.hexdigest(self.filename)
    end

    super
  end

  def extname
    File.extname(File.basename(self.original_filename)).downcase
  end

  def styles
    {
      cover: 1280.0,
      thumb: 755.0,
      medium: 360.0
    }
  end

  def retouch
    image = MiniMagick::Image.open(self.path(:original))
    __original_width = image[:width]

    if self.frames.to_i <= 1 # not gif
      self.styles.each do |k,v|

        # missing only
        next if File.exist?(self.path(k))

        rate = v / __original_width
        rate = 1 if rate > 1
        __new_width = __original_width * rate
        __new_image = MiniMagick::Image.open image.tempfile.path
        __new_image.resize __new_width

        self.dimensions[k] = "#{__new_image[:width]}x#{__new_image[:height]}"
        __new_image.combine_options do |c|
          c.background '#FFFFFF'
          c.alpha 'remove'
        end
        __new_image.format "jpg"
        __new_image.combine_options do |c|
          c.strip
          c.quality "85"
          c.interlace "plane"
        end

        __filename = self.path(k)
        __new_image.write __filename
        self.filesize[k] = __new_image.size
        FileUtils.chmod 0644, __filename
      end
    end
  end

  def attachment=(filedata)
    raise 'filedata is missing.' if filedata.blank?

    if filedata.respond_to? :original_filename
      self.original_filename = filedata.original_filename.to_s.downcase
      image = MiniMagick::Image.read(filedata.read)
    else
      self.original_filename = filedata.to_s.downcase
      image = MiniMagick::Image.open(filedata)
    end

    if self.extname.blank?
      self.original_filename = self.original_filename + Time.now.to_f.to_s + ".jpg"
      image.format "jpg"
    end

    self.force_set_created_at
    self.filename = Time.now.to_f.to_s + self.extname


    image.auto_orient
    if image[:width] > 2048
      image.resize 2048
    end
    image.write self.path(:original)

    self.filesize[:original] = image.size
    __original_width = image[:width]
    __original_height = image[:height]
    self.dimensions[:original] = "#{__original_width}x#{__original_height}"
    self.details[:ratio] = (__original_height.to_f / __original_width.to_f) * 100.0
    self.details[:type] = image.type
    self.details[:frames] = image.frames.length
    self.details[:mime_type] = image.mime_type
    self.details[:shape] = if __original_width == __original_height
      "square"
    elsif __original_width > __original_height
      (__original_width / __original_height.to_f < 1.3) ? "wide-square" : "wide"
    elsif __original_width < __original_height
      (__original_height / __original_width.to_f < 1.3) ? "narrow-square" : "narrow"
    end

    if self.details[:frames].to_i <= 1 # not animated gif
      self.styles.each do |k,v|
        rate = v / __original_width
        rate = 1 if rate > 1
        __new_width = __original_width * rate
        __new_image = MiniMagick::Image.open image.tempfile.path
        __new_image.resize __new_width

        self.dimensions[k] = "#{__new_image[:width]}x#{__new_image[:height]}"
        __new_image.combine_options do |c|
          c.background '#FFFFFF'
          c.alpha 'remove'
        end
        __new_image.format "jpg"
        __new_image.combine_options do |c|
          c.strip
          c.quality "85"
          c.interlace "plane"
        end

        __filename = self.path(k)
        __new_image.write __filename
        self.filesize[k] = __new_image.size
        FileUtils.chmod 0644, __filename
      end

      info = %x(convert '#{self.path(:medium)}' -resize 1x1 -depth 8 txt:)
      self.hex = /\s#([0-9a-f]{6,8})\s/i.match(info).to_a.last
      self.rgb = CustomUtils.hexToRGB(self.hex)
      self.hsv = CustomUtils.rgbToHsv(*self.rgb)
    end
  end

  def force_set_created_at
    self.created_at = Time.now if self.created_at.blank?
  end

  def created_at_to_path
    "#{self.created_at.year}/#{self.created_at.month}/#{self.created_at.day}/#{self.hashkey}"
  end

  def destroy_assets
    FileUtils.rm_rf self.path
  end

end
