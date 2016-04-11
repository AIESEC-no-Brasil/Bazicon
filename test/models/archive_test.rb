require 'minitest/autorun'

class ArchiveTest < Minitest::Test
  def setup

  end

  def teardown
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  def test_list_every_file_at_mc_level
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.all
    assert(files.count == 0, "DB has register. It was supposed to be empty but it has" + files.count.to_s + " registers")

    file = Archive.new
    file.office = office_mc
    file.save

    files = ArchiveDAO.all
    assert(files.count == 1, "DB has register. It was supposed to be empty but it has" + files.count.to_s + " registers")

    file = Archive.new
    file.office = office_lc
    file.save

    files = ArchiveDAO.all
    assert(files.count == 2, "DB has register. It was supposed to be empty but it has" + files.count.to_s + " registers")
  end

  def test_list_every_file_at_lc_level

  end

  def test_list_every_public_file

  end

  def test_list_every_private_file

  end

  def test_list_every_pdf_file

  end

  def test_list_every_word_file

  end

  def test_list_every_excel_file

  end

  def test_list_every_ppt_file

  end

  def test_list_every_image_file

  end

  def test_list_every_sound_file

  end

  def test_list_every_video_file

  end

  def test_list_every_other_file

  end
end
