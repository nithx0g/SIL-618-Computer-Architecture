
public class Predictor2400 extends Predictor {
	Table BHR;
	Table PHT;
	int entries1 = 128;
	int BHR_index_bits = 7;
	int bitsPerEntry1 = 4;
	int entries2 = 512;
	int PHT_index_bits = 9;
	int bitsPerEntry2 = 3;
	public Predictor2400() {
		BHR = new Table(entries1,bitsPerEntry1);
		PHT = new Table(entries2,bitsPerEntry2);
		for (int i=0;i<entries1;i++){
			BHR.setBit(i,0,false);
			for(int j=1;j<bitsPerEntry1;j++){
				BHR.setBit(i,j,false);
			}
		}
		for (int i=0;i<entries2;i++){
			PHT.setBit(i,0,false);
			for(int j=1;j<bitsPerEntry2;j++){
				PHT.setBit(i,j,false);
			}
		}
	}


	public void Train(long address, boolean outcome, boolean predict) {
		String bits = Long.toBinaryString(address);
		String BHR_index_string = "";
		int start = bits.length()-9;
		for (int i=start;i<start+BHR_index_bits;i++){
			BHR_index_string = BHR_index_string + bits.charAt(i);
		}
		int BHR_index = Integer.parseInt(BHR_index_string,2);
		int BHR_value = BHR.getInteger(BHR_index,0,bitsPerEntry1-1);
		int pc_bits = extractLastBits(address,PHT_index_bits-bitsPerEntry1) ;
		int PHT_index = (pc_bits << bitsPerEntry1) + BHR_value;
		
		int counterValue = PHT.getInteger(PHT_index,0,bitsPerEntry2-1);
		if(outcome){
			if(counterValue != Math.pow(2,bitsPerEntry2) - 1){
				counterValue = counterValue + 1;
				PHT.setInteger(PHT_index,0,bitsPerEntry2-1,counterValue);
			}
		}
		else{
			if (counterValue != 0){
				counterValue = counterValue - 1;
				PHT.setInteger(PHT_index,0,bitsPerEntry2-1,counterValue);
			}
		}

		String BHR_value_bits = Integer.toBinaryString(BHR_value);
		//BHR_value_bits = BHR_value_bits.substring(BHR_value_bits.length()-bitsPerEntry1);
		while(BHR_value_bits.length() != bitsPerEntry1){
			BHR_value_bits = "0" + BHR_value_bits;
			//System.out.println(BHR_value_bits);
		}
		
		String string = "";
		
		for (int i=1;i<bitsPerEntry1;i++){
			string = string + BHR_value_bits.charAt(i-1);
		}
		if(outcome){
			string = '1' + string;
		}
		else{
			string = '0' + string;
		}
		
		//System.out.println(string.toString());
		BHR.setInteger(BHR_index,0,bitsPerEntry1-1,Integer.parseInt(string.toString(),2));
	}


	public boolean predict(long address){
		///extract k bits from PC say 8,9,10
		String bits = Long.toBinaryString(address);
		String BHR_index_string = "";
		int start = bits.length()-9;
		for (int i=start;i<start+BHR_index_bits;i++){
			BHR_index_string = BHR_index_string + bits.charAt(i);
		}
		int BHR_index = Integer.parseInt(BHR_index_string,2);
		int BHR_value = BHR.getInteger(BHR_index,0,bitsPerEntry1-1);
		int pc_bits = extractLastBits(address,PHT_index_bits-bitsPerEntry1) ;

		int PHT_index = (pc_bits << bitsPerEntry1) + BHR_value;

		boolean prediction = PHT.getBit(PHT_index,0);
		return prediction;
	}

	public int extractLastBits(long address,int PCBits){
		

		String bits = Long.toBinaryString(address);
		return Integer.parseInt(bits.substring(bits.length()-PCBits),2);
	}

}