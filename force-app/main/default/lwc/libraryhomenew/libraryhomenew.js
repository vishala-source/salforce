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


    // transactionColumns = [
    //     { label: 'Transaction Name', fieldName: 'Name' },
    //     { label: 'Book Name', fieldName: 'BookName' },
    //     { label: 'Member Name', fieldName: 'MemberName' },
    //     { label: 'Issue Date', fieldName: 'Issue_Date', type: 'date' },
    //     { label: 'Due Date', fieldName: 'Due_Date', type: 'date' },
    //     { label: 'Return Date', fieldName: 'Return_Date', type: 'date' },
    //     { label: 'Status', fieldName: 'Status' }
    // ];
    transactionColumns = [
        { label: 'Transaction Name', fieldName: 'Name' },
        { label: 'Book Name', fieldName: 'BookName' },
        { label: 'Issue Date', fieldName: 'Issue_Date', type: 'date' },
        { label: 'Due Date', fieldName: 'Due_Date', type: 'date' },
        { label: 'Return Date', fieldName: 'Return_Date', type: 'date' },
        { label: 'Status', fieldName: 'Status' }
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

    // @wire(getTransactions)
    // wiredTransactions({ error, data }) {
    //     if (data) {
    //         console.log('✅ Transactions fetched successfully:', JSON.stringify(data)); 
    //         // Assign the transactions to display only those belonging to the logged-in user
    //         this.transactions = data.map(transaction => ({
    //             ...transaction,
    //             BookName: transaction.BookName ? transaction.BookName : 'N/A',
    //             MemberName: transaction.MemberName ? transaction.MemberName : 'N/A',
    //             Issue_Date: transaction.Issue_Date ? transaction.Issue_Date : null,
    //             Due_Date: transaction.Due_Date ? transaction.Due_Date : null,
    //             Return_Date: transaction.Return_Date ? transaction.Return_Date : null
    //         }));
    //     } else if (error) {
    //         console.error('❌ Error fetching transactions:', JSON.stringify(error));
    //     }
    // }
    @wire(getTransactions)
wiredTransactions({ error, data }) {
    if (data) {
        console.log('✅ Transactions fetched successfully:', JSON.stringify(data)); 
        // Assign the transactions to display in the UI
        this.transactions = data.map(transaction => ({
            Id: transaction.Id,
            Name: transaction.Name,
            Issue_Date: transaction.Issue_Date__c, 
            Due_Date: transaction.Due_Date__c, 
            Return_Date: transaction.Return_Date__c, 
            Status: transaction.Status__c
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
