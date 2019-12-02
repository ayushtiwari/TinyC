//Average

int main()
{
  int x[100];
  int n,m,i;
  int sum = 0;
  int err=1;
  prints("\n************************ Average *********************\n");
  prints("\nEnter the number of elements in array\n");
  n=readi(&err);
  prints("\nEnter the elements of the array one by one\n");
  for(i=0;i<n;i++)
  {
	x[i]=readi(&err);
  sum = sum + x[i];
  }
  
  int len;
  len=sum/n;
  prints("\nAverage is (in integer) : \n");
  printi(len);
  prints("\n******************************\n");
  return 0;
}
