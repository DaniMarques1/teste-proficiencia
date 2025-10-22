from django import forms
from .models import Usuarios
from django.core.exceptions import ValidationError
import dns.resolver

# A list of domains you want to block
BLOCKED_DOMAINS = {
    'mailinator.com',
    'temp-mail.org',
    '10minutemail.com',
    'sharklasers.com',
    # Common Typosquatting Domains
    'gmil.com',     # gmail.com typo
    'gmai.com',     # gmail.com typo
    'gmail.con',    # gmail.com typo
    'hotmal.com',   # hotmail.com typo
    'hotnail.com',  # hotmail.com typo
    'yaho.com',     # yahoo.com typo
    'aol.con',      # aol.com typo
    'outlok.com',   # outlook.com typo
}

class UsuarioForm(forms.ModelForm):
    class Meta:
        model = Usuarios
        fields = ['nome', 'email', 'aceita_contato']

    def clean_email(self):
        """
        Validates the email at 3 levels:
        1. Does it already exist in the DB?
        2. Is it from a disposable domain?
        3. Does the domain exist and can it receive mail (MX check)?
        """
        email = self.cleaned_data.get('email')

        if not email:
            # If the field is optional or failed basic validation
            return email

        # --- Check 1: Email already exists (Your original logic) ---
        # This is the fastest check, so it comes first.
        if Usuarios.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError("This email is already registered.")

        # --- Check 2: Disposable Domains ---
        try:
            # Get the domain (the part after the @)
            domain = email.split('@')[1]
            if domain.lower() in BLOCKED_DOMAINS:
                raise forms.ValidationError("This email provider is not allowed.")
        except (IndexError, AttributeError):
            # If the split fails, the format is invalid
            raise forms.ValidationError("Invalid email format.")

        # --- Check 3: MX Records (Domain Existence) ---
        try:
            # Try to resolve the MX records for the domain
            mx_records = dns.resolver.resolve(domain, 'MX')
            if not mx_records:
                # If no MX records, try an A record (fallback)
                dns.resolver.resolve(domain, 'A')

        except dns.resolver.NXDOMAIN:
            # NXDOMAIN = Non-Existent Domain
            raise forms.ValidationError("The domain for this email does not seem to exist.")
        except dns.resolver.NoAnswer:
            # The domain exists, but has no mail configuration (MX or A)
            raise forms.ValidationError("This domain does not seem to be configured to receive email.")
        except dns.resolver.Timeout:
            # The query timed out
            raise forms.ValidationError("We could not verify the email domain. Please try again.")
        except Exception as e:
            # Catch other DNS errors
            raise forms.ValidationError("An error occurred while verifying your email.")

        # If all checks passed, return the cleaned email
        return email