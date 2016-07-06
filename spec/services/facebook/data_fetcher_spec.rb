require 'spec_helper'

module Facebook
  describe DataFetcher, type: :service do
    let(:token)   { 'EAACEdEose0cBAIHZBBKjt9iMpCba7L9dGrxlZBgZBBXAfOgKe2C7hULf6OU8HG8yzSEN6n44Ul7WyVjth7inmGD8OIheEnUcUpl2Jr9TxiIZA1GTc7MWsbrBy3IGWzN4RaC8hjiYklcZBnJ3ZAAR2sIoWfv9eU60swV1jEdsZCuNQZDZD' }
    let(:uid)     { '10204225122802197' }
    let(:fetcher) { described_class.new(token) }

    describe '#fetch_friends', :vcr do
      it 'gets user friends' do
        expect(fetcher.fetch_friends).to eq([
                                              {'name'=>'Tobias Wonderland', 'id'=>'521453992'},
                                              {'name'=>'Gui Porto', 'id'=>'528597901'},
                                              {'name'=>'Henrique Bastos', 'id'=>'562073097'},
                                              {'name'=>'Philippe Rosa', 'id'=>'605325441'},
                                              {'name'=>'Giulio Dariano Bottari', 'id'=>'646503417'},
                                              {'name'=>'Gustavo Lima', 'id'=>'682086625'},
                                              {'name'=>'Magno Mathias', 'id'=>'10203005152306501'},
                                              {'name'=>'Cleberson Gordirio', 'id'=>'10205741309029560'},
                                              {'name'=>'Gustavo Hingel Morada', 'id'=>'1206836370'},
                                              {'name'=>'Bruno Antunes', 'id'=>'1418678785'},
                                              {'name'=>'Ricardo Goldstein', 'id'=>'10201879337255366'},
                                              {'name'=>'João Paulo Lethier', 'id'=>'1705340857'},
                                              {'name'=>'André Mattos', 'id'=>'100000034040387'},
                                              {'name'=>'Rafael Grillo', 'id'=>'780864248600935'},
                                              {'name'=>'Hugo Tamaki', 'id'=>'100000326291231'},
                                              {'name'=>'Katharina Kossak', 'id'=>'897243443631505'},
                                              {'name'=>'Pablo Ribeiro', 'id'=>'100000399294185'},
                                              {'name'=>'Carolina Zamith Cunha', 'id'=>'772944042729308'},
                                              {'name'=>'Eduardo Thomaz de Carvalho', 'id'=>'831571423538829'},
                                              {'name'=>'Raissa Ferreira', 'id'=>'100000647702265'},
                                              {'name'=>'Eduardo Alencar', 'id'=>'720140671366365'},
                                              {'name'=>'Felipe Ribeiro', 'id'=>'882980341753541'},
                                              {'name'=>'Luis Vasconcellos', 'id'=>'100001449814694'},
                                              {'name'=>'Carlos Eduardo Penna', 'id'=>'100001557061767'},
                                              {'name'=>'Carlos Henrique Sant\' Ana', 'id'=>'782877135108614'},
                                              {'name'=>'Rafael Rêgo Drumond', 'id'=>'100001730876765'},
                                              {'name'=>'João Felipe Nicolaci Pimentel', 'id'=>'100001891377345'},
                                              {'name'=>'Eduarosemel Ribeiro', 'id'=>'916701648403548'},
                                              {'name'=>'Gustavo Honorato', 'id'=>'100002182470868'},
                                              {'name'=>'Robson Morais', 'id'=>'100002523742601'},
                                              {'name'=>'Leonardo Picciani', 'id'=>'100007124167949'},
                                              {'name'=>'Alexander Bogomolov', 'id'=>'108978046155141'}
                                            ])
      end
    end

    describe '#fetch_gender', :vcr do
      it 'gets user gender' do
        expect(fetcher.fetch_gender).to eq('male')
      end
    end
  end
end
