# frozen_string_literal: true

class ClientToken
  attr_reader :cid, :vid, :fp
  attr_writer :cid, :vid, :fp

  def initialize(cid, vid, fp)
    @cid = cid
    @vid = vid
    @fp = fp
  end
end
