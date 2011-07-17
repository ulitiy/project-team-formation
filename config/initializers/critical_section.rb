#Реализация MUTEX критической секции с помощью эксклюзивной блокировки на запись файлов ОС
#один файл - один мьютекс
class CriticalSection
  def start
    @file=File.open "#{Dir.tmpdir}/ptf.#{@file_str}.lock", 'w'
    @file.flock File::LOCK_EX
  end

  def initialize file
    @file_str=file.to_s
  end

  def finish
    @file.flock File::LOCK_UN
  end
end

