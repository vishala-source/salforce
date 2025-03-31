import { LightningElement, wire, track } from 'lwc';
import getBooks from '@salesforce/apex/BookController.getBooks';
import getTransactions from '@salesforce/apex/TransactionController.getTransactions';

export default class LibraryHome extends LightningElement {
    @track books = [];
    @track transactions = [];
    
    @track showBooks = false;
    @track showTransactions = false;

    bookColumns = [
        { label: 'Book Name', fieldName: 'Name' },
        { label: 'Author', fieldName: 'Author__c' },
        { label: 'Genre', fieldName: 'Genre__c' },
        { label: 'Available Copies', fieldName: 'Available_Copies__c', type: 'number' }
    ];


    transactionColumns = [
        { label: 'Transaction Name', fieldName: 'Name' },
         { label: 'Book Name', fieldName: 'BookName' },
        { label: 'Member Name', fieldName: 'MemberName' },
        { label: 'Issue Date', fieldName: 'Issue_Date__c', type: 'date' },
        { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date' },
        { label: 'Return Date', fieldName: 'Return_Date__c', type: 'date' }
    ];
    
    
    @wire(getBooks)
    wiredBooks({ error, data }) {
        if (data) {
            console.log('✅ Books fetched successfully:', JSON.stringify(data)); // Debugging
            this.books = data;
        } else if (error) {
            console.error('❌ Error fetching books:', JSON.stringify(error)); // Debugging
        }
    }

    @wire(getTransactions)
    wiredTransactions({ error, data }) {
        if (data) {
            console.log('✅ Transactions fetched successfully:', JSON.stringify(data)); 
            // Assign the transactions to display only those belonging to the logged-in user
            this.transactions = data.map(transaction => ({
                ...transaction,
                BookName: transaction.BookName ? transaction.BookName : 'N/A'
            }));
        } else if (error) {
            console.error('❌ Error fetching transactions:', JSON.stringify(error));
        }
    }
    
    async handleViewBooks() {
        this.showBooks = true;
        this.showTransactions = false;
    }
    async handleViewTransactions() {
        this.showBooks = false;
        this.showTransactions = true;
    }
}