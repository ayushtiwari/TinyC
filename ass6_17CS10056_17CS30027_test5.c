//Bubble Sort

void BubbleSort(int arr[], int n)
{
	int i, j, tmp;

	for(i = 0 ; i < n - 1 ; i++)
	{
		for(j = 0 ; j < n - i - 1 ; j++)
		{
			if(arr[j] > arr[j+1])
			{
				tmp = arr[j];
				arr[j] = arr[j+1];
				arr[j+1] = tmp;
			}
		}
	}
}


void PrintArray(int arr[], int size)
{
	int i;



	for(i = 0 ; i < size ; i++)
	{
		printi(arr[i]);
		prints("\n");
	}

}

int main()
{
    int arr[100],i,n;
	int err=1;
	
	prints("\n********************* Bubble Sort ***********************\n");
    prints("\nEnter the number of elements\n");
    
    n=readi(&err);
	
	prints("\nEnter the elements of the array one by one i.e. use a new line for every element: \n"); 
    
    for(i=0;i<n;i++)
    {
        arr[i]=readi(&err);
    }
	
	BubbleSort(arr,n);

	prints("\nThe sorted elements are: \n");

	PrintArray(arr, n);
	
	prints("\n*******************************************************\n");
	
	return 0;
}

