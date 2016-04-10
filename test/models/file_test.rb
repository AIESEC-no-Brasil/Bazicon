require 'minitest/autorun'

class FileTest < Minitest::Test
  def teardown
    Rake::Task['db:reset'].invoke
  end

  def test_list_every_file_at_mc_level

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
