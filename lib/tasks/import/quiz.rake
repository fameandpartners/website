require 'roo'

namespace :import do
  namespace :quiz do
    task :taxons => :environment do
      raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

      file_path = ENV['FILE_PATH']

      if file_path =~ /\.xls$/
        book = Roo::Excel.new(file_path, false, :warning)
      elsif file_path =~ /\.xlsx$/
        # false - packed, warning - ignore not xslx format
        book = Roo::Excelx.new(file_path, false, :warning)
      else
        raise 'Invalid file type'
      end

      book.default_sheet = book.sheets.first

      rules = {
        prom_dresses: { rows: 3..37 }, # Runway
        outfits: { rows: 39..73 }, # Street style
        oscar_dresses: { rows: 75..109 } # Red Carpet
      }

      quiz = Quiz.last

      rules.each do |partial, options|
        question = quiz.questions.find_by_partial!(partial)

        options[:rows].each do |row|
          values = book.row(row).compact

          answer = question.answers.where('LOWER(code) = ?', values.shift.downcase.strip).first

          raise ActiveRecord::RecordNotFound unless answer.present?

          answer.taxons.clear

          values.each do |taxon_name|
            taxon = Spree::Taxon.where('LOWER(name) = ?', taxon_name.downcase.strip).first

            # raise ActiveRecord::RecordNotFound unless taxon.present?

            if taxon.present?
              answer.taxons << taxon
            else
              puts "Can not find Spree::Taxon with name \"#{taxon_name}\""
            end
          end
        end
      end
    end
  end
end
