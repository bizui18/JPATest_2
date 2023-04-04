package com.JPATest.temp;

public class Thread_main {
	public static void main(String[] args) throws InterruptedException {
		// main daemon
		
		Thread[] ts = new Thread_thread[10000];
		for (int i = 0; i < ts.length; i++) {
			ts[i] = new Thread_thread(1000);
			ts[i].start();
//			ts[i].join();		
		}

		for (int i = 0; i < ts.length; i++) {
//			System.out.println(i+" : "+ts[i].getState() );
		}
		
		
		for (int i = 0; i < ts.length; i++) {
			ts[i].join();
//			if(ts[i].getState().equals(Thread.State.RUNNABLE)) {
//				System.out.println("yes");
//			}
		}
		
		// thread 상태 체크!
		for (int i = 0; i < ts.length; i++) {
//			System.out.println(i+" : "+ts[i].getState() );
		}
		System.out.println("total : "+Thread_thread.Count);
		
		for (int i = 0; i < 1000000; i++) {
			
		}
		System.out.println("total : "+Thread_thread.Count);
		System.out.println("total : "+Thread_thread.get());
	}
}
