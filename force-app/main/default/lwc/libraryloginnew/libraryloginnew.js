import { LightningElement, track, wire } from 'lwc';
import verifyMemberLogin from '@salesforce/apex/LibraryLoginController.verifyMemberLogin';

export default class LibraryLogin extends LightningElement {
    @track email = '';
    @track password = '';
    @track errorMessage = '';
    
    handleEmailChange(event) {
        this.email = event.target.value.trim();
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
    }

    async handleLogin() {
        this.errorMessage = ''; // Clear previous errors

        if (!this.email || !this.password) {
            this.errorMessage = 'Email and Password are required!';
            return;
        }

        try {
            const response = await verifyMemberLogin({ email: this.email, password: this.password });
            console.log('Login Response:', response);

            if (response === 'SUCCESS') {
                this.errorMessage = '';
                sessionStorage.setItem('memberEmail', this.email); // Store session data
                window.location.href = '/library-home'; // Redirect to home page
            } else if (response === 'INVALID') {
                this.errorMessage = 'Invalid email or password!';
            } else if (response === 'INACTIVE') {
                this.errorMessage = 'Your account is inactive. Please contact support.';
            } else if (response === 'EXPIRED') {
                this.errorMessage = 'Your membership has expired!';
            } else {
                this.errorMessage = 'Login failed. Please try again.';
            }
        } catch (error) {
            console.error('Login Error:', error);
            this.errorMessage = 'An error occurred. Please try again later.';
        }
    }
}
