import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import verifyMemberLogin from '@salesforce/apex/LibraryLoginController.verifyMemberLogin';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LibraryLogin extends NavigationMixin(LightningElement) {
    email = '';
    password = '';

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
    }

    async handleLogin() {
        if (!this.email || !this.password) {
            this.showToast('Error', 'Please enter Email and Password', 'error');
            return;
        }
    
        verifyMemberLogin({ email: this.email, password: this.password })
            .then(result => {
                if (result === 'SUCCESS') {
                    this.showToast('Success', 'Login Successful!', 'success');
    
                    // ✅ Redirect using window.location to your community URL
                    window.location.href = 'https://orgfarm-65833e947b-dev-ed.develop.my.site.com/librarymanagement/s/library-home';
    
                } else if (result === 'INACTIVE') {
                    this.showToast('Error', 'Your membership is inactive.', 'error');
                } else if (result === 'EXPIRED') {
                    this.showToast('Error', 'Your membership has expired.', 'error');
                } else {
                    this.showToast('Error', 'Invalid Email or Password.', 'error');
                }
            })
            .catch(error => {
                console.error('Login Error:', error);
                this.showToast('Error', 'An error occurred during login.', 'error');
            });
    }
    showToast(title, message, variant) {
     const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}
