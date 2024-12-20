export function isValidPhoneNumber(phone: string): boolean {
  const phoneRegex = /^(\+?\d{1,3}[- ]?)?\d{11}$/;
  return phoneRegex.test(phone);
}
export function isValidPassword(password: string): boolean {
  if (password.length < 8) {
    return false;
  }
  const hasUpperCase = /[A-Z]/.test(password);
  const hasLowerCase = /[a-z]/.test(password);
  const hasNumber = /\d/.test(password);
  return hasUpperCase && hasLowerCase && hasNumber;
}
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  return emailRegex.test(email);
}
export function isValidUsername(username: string): boolean {
  const usernameRegex = /^[a-zA-Z0-9]{5,15}$/;
  return usernameRegex.test(username);
}





