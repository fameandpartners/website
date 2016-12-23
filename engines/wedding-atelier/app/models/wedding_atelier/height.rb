module WeddingAtelier
  class Height
    class << self
      def definitions
        {
          petit: [
            "4'10\"/147cm",
            "4'11\"/150cm",
            "5'0\"/152cm",
            "5'1\"/155cm",
            "5'2\"/157cm",
            "5'3\"/160cm"
          ],
          standard: [
            "5'4\"/163cm",
            "5'5\"/165cm",
            "5'6\"/167cm",
            "5'7\"/170cm",
            "5'8\"/173cm",
            "5'9\"/175cm",
          ],
          tall: [
            "5'10\"/178cm",
            "5'11\"/180cm",
            "6'0\"/183cm",
            "6'1\"/185cm",
            "6'2\"/188cm",
            "6'3\"/190cm",
            "6'4\"/193cm",
            "6'5\"/196cm"
          ]
        }
      end
    end
  end
end
