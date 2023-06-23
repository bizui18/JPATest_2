package com.JPATest.temp;

public class Thread_thread extends Thread{

	public static volatile int Count=0;
	private int n;
	private int temp;
	private static int temp2;
	public Thread_thread(int n) {
		this.n =n;
//		temp =0;
//		System.out.println(this.getClass().hashCode());
	}
	@Override
	public void run() {
		// TODO Auto-generated method stub
		for (int i = 0; i < n; i++) {
			Count+=1;
//			temp+=1;
//			temp2+=1;
		}
//		Count+=temp;
		System.out.printf("이 쓰레드에서 %d번을 더했습니다.: %s\n",temp,Thread.currentThread().getName());
//		System.out.println(Count);
	}
	
	public static int get() {
		return temp2;
	}
}
