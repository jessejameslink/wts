package m.pool.socket;

public class PoolTest implements Runnable{
	private int count = 0;
	public PoolTest(int i ){
		count = i;
	}
	@Override
	public void run() {
		try {
			Pool pool = new Pool();
			Connection c = pool.getConnection();
			
			Thread.sleep(1000);
			if(c != null)	//System.out.println("pool get : " + count);	
			c.close();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		for(int i = 0; i < 1000; i++){
			PoolTest test = new PoolTest(i);
			Thread thread = new Thread(test);
			thread.start();
		}
	}

	

}
