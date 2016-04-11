require 'minitest/autorun'

class ArchiveTest < Minitest::Test
  def setup

  end

  def teardown
    Archive.all.each do |archive|
      archive.destroy
    end
    ExpaApplication.all.each do |application|
      application.destroy
    end
    ExpaCurrentPosition.all.each do |current_position|
      current_position.destroy
    end
    ExpaOffice.all.each do |office|
      office.destroy
    end
    ExpaOpportunity.all.each do |opportuniy|
      opportuniy.destroy
    end
    ExpaPerson.all.each do |person|
      person.destroy
    end
    ExpaTeam.all.each do |team|
      team.destroy
    end
  end

  def test_list_every_file_at_mc_level
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.all
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.save

    files = ArchiveDAO.all
    assert(files.count == 1, 'DB has register. It was supposed to have 1 register, but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.save

    files = ArchiveDAO.all
    assert(files.count == 2, 'DB has register. It was supposed to have 2 registers, but it has ' + files.count.to_s + ' registers')
  end

  def test_list_every_file_at_lc_level
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.save

    files = ArchiveDAO.list_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1 register, but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.save

    files = ArchiveDAO.list_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1 register, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to have 2 registers, but it has ' + files.count.to_s + ' registers')
  end

  def test_list_every_public_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_all_public
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.save

    files = ArchiveDAO.list_public_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_all_public
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.save

    files = ArchiveDAO.list_public_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_all_public
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_all_public
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_all_public
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_private_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_private_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.save

    files = ArchiveDAO.list_private_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.save

    files = ArchiveDAO.list_private_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.is_private = true
    file.save

    files = ArchiveDAO.list_private_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.is_private = true
    file.save

    files = ArchiveDAO.list_private_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_pdf_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_pdf_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_pdf_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'pdf'
    file.save

    files = ArchiveDAO.list_public_pdf_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_pdf_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'pdf'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_pdf_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_pdf_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'pdf'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_pdf_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_pdf_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'pdf'
    file.save

    files = ArchiveDAO.list_public_pdf_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_pdf_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_pdf_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_word_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_word_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_word_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'word'
    file.save

    files = ArchiveDAO.list_public_word_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_word_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'word'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_word_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_word_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'word'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_word_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_word_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'word'
    file.save

    files = ArchiveDAO.list_public_word_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_word_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_word_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_excel_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_excel_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_excel_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'excel'
    file.save

    files = ArchiveDAO.list_public_excel_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_excel_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'excel'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_excel_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_excel_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'excel'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_excel_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_excel_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to have 2, but it has ' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'excel'
    file.save

    files = ArchiveDAO.list_public_excel_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_excel_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to have 1, but it has ' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_excel_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to have 2, but it has ' + files.count.to_s + ' registers')
  end

  def test_list_every_ppt_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_ppt_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_ppt_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'ppt'
    file.save

    files = ArchiveDAO.list_public_ppt_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_ppt_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'ppt'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_ppt_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_ppt_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'ppt'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_ppt_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_ppt_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'ppt'
    file.save

    files = ArchiveDAO.list_public_ppt_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_ppt_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_ppt_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_image_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_image_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_image_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'image'
    file.save

    files = ArchiveDAO.list_public_image_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_image_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'image'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_image_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_image_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'image'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_image_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_image_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'image'
    file.save

    files = ArchiveDAO.list_public_image_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_image_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_image_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_sound_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_sound_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_sound_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'sound'
    file.save

    files = ArchiveDAO.list_public_sound_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_sound_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'sound'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_sound_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_sound_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'sound'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_sound_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_sound_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'sound'
    file.save

    files = ArchiveDAO.list_public_sound_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_sound_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_sound_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_video_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_video_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_video_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'video'
    file.save

    files = ArchiveDAO.list_public_video_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_video_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'video'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_video_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_video_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'video'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_video_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_video_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'video'
    file.save

    files = ArchiveDAO.list_public_video_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_video_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_video_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
  end

  def test_list_every_other_file
    office_mc = ExpaOffice.new
    office_mc.xp_id = 1606 #BRAZIL
    office_mc.save

    office_lc = ExpaOffice.new
    office_lc.xp_id = 100 #ARACAJU
    office_lc.save

    files = ArchiveDAO.list_public_other_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_other_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'other'
    file.save

    files = ArchiveDAO.list_public_other_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_other_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_mc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_mc
    file.type_of_file = 'other'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_other_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_other_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'other'
    file.is_private = true
    file.save

    files = ArchiveDAO.list_public_other_from_office(office_lc)
    assert(files.count == 0, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_other_from_office(office_mc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')

    file = Archive.new
    file.office = office_lc
    file.type_of_file = 'other'
    file.save

    files = ArchiveDAO.list_public_other_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_lc)
    assert(files.count == 1, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_public_other_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' registers')
    files = ArchiveDAO.list_private_other_from_office(office_mc)
    assert(files.count == 2, 'DB has register. It was supposed to be empty but it has' + files.count.to_s + ' register')
  end
end
