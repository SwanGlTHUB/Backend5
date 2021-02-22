public inherited sharing class CustomGenerator {
    static final Integer alphaNumericsCount = 36;
    
    public static String generateRandomAlphanumericString(Integer length) {
        String result = '';
        
        for(Integer i = 0; i < length; i++){
            result += CustomGenerator.getAlphanumericByIndex(Math.round(Math.random() * 35));
        }

        return result;
    }

    private static String getAlphanumericByIndex(Integer index){
        if(index < 10){
            return String.fromCharArray( new List<integer> { 48 + index } );
        }
        if(index >= 10 && index <CustomGenerator.alphaNumericsCount){
            return String.fromCharArray( new List<integer> { 65 + (index - 10) } );
        }
        return 'a';
    }
}
