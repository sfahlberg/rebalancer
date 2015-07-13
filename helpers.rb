class String
  def is_letter?
    !self.match(/^[[:alpha:]]+$/).nil?
  end
end
