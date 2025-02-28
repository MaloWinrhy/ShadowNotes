use chacha20poly1305::{ChaCha20Poly1305, Key, Nonce, aead::Aead};
use chacha20poly1305::KeyInit;
use blake3;
use flutter_rust_bridge::frb;
use rand::{Rng, thread_rng};

#[frb(sync)]
pub fn encrypt_note(note: String, password: String) -> (Vec<u8>, Vec<u8>) {
    let key = derive_key_from_password(&password);
    let cipher = ChaCha20Poly1305::new(&key);

    let nonce = generate_nonce();
    let ciphertext = cipher.encrypt(&nonce, note.as_bytes()).expect("Encryption failed");

    (nonce.to_vec(), ciphertext)
}

#[frb(sync)]
pub fn decrypt_note(nonce: Vec<u8>, encrypted_note: Vec<u8>, password: String) -> String {
    let key = derive_key_from_password(&password);
    let cipher = ChaCha20Poly1305::new(&key);

    let nonce = Nonce::from_slice(&nonce);
    let decrypted = cipher.decrypt(nonce, encrypted_note.as_ref()).expect("Decryption failed");

    String::from_utf8(decrypted).expect("UTF-8 decoding failed")
}

fn derive_key_from_password(password: &str) -> Key {
    let hash = blake3::hash(password.as_bytes());
    Key::from_slice(&hash.as_bytes()[..32]).clone()
}

fn generate_nonce() -> Nonce {
    let mut nonce_bytes = [0u8; 12];
    thread_rng().fill(&mut nonce_bytes);
    *Nonce::from_slice(&nonce_bytes)
}