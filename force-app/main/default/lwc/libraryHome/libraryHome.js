import { LightningElement, wire, track } from 'lwc';
import getBooks from '@salesforce/apex/BookController.getBooks';
import getMembers from '@salesforce/apex/MemberController.getMembers';
import getTransactions from '@salesforce/apex/TransactionController.getTransactions';

export default class LibraryHome extends LightningElement {
    @track books = [];
    @track members = [];
    @track transactions = [];
    
    @track showBooks = false;
    @track showMembers = false;
    @track showTransactions = false;

    bookColumns = [
        { label: 'Book Name', fieldName: 'Name' },
        { label: 'Author', fieldName: 'Author__c' },
        { label: 'Genre', fieldName: 'Genre__c' },
        { label: 'Available Copies', fieldName: 'Available_Copies__c', type: 'number' }
    ];

    memberColumns = [
        { label: 'Member Name', fieldName: 'Member_Name__c' },
        { label: 'Email', fieldName: 'Email_Address__c', type: 'email' },
        { label: 'Phone Number', fieldName: 'Phone_Number__c', type: 'phone' },
        { label: 'Membership Expiry Date', fieldName: 'Membership_Expiry_Date__c', type: 'date' }
    ];

    transactionColumns = [
        { label: 'Transaction Name', fieldName: 'Name' },
        { label: 'Book', fieldName: 'Book__c' },
        { label: 'Member', fieldName: 'Library_Member__c' },
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

    @wire(getMembers)
    wiredMembers({ error, data }) {
        if (data) {
            this.members = data;
        }
    }

    @wire(getTransactions)
    wiredTransactions({ error, data }) {
        if (data) {
            this.transactions = data;
        }
    }

    async handleViewBooks() {
        this.showBooks = true;
        this.showMembers = false;
        this.showTransactions = false;
    }

   async handleViewMembers() {
        this.showBooks = false;
        this.showMembers = true;
        this.showTransactions = false;
    }

    async handleViewTransactions() {
        this.showBooks = false;
        this.showMembers = false;
        this.showTransactions = true;
    }
}
