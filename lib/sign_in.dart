import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken);
  final FirebaseUser user = await _auth.signInWithCredential(credential);

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentuser = await _auth.currentUser();
  assert(user.uid == currentuser.uid);
  print("here");
  return 'signInWithGoogle succeeded: $user';
}

Future<String> signInWithEmail(String email, String password) async {
  print(email);
  print(password);
  final FirebaseUser user =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentuser = await _auth.currentUser();
  assert(user.uid == currentuser.uid);
  print(email + password);
  return 'signInWithemail succeeded: $user';
}

Future<String> signUpWithEmail(String email, String password) async {
  FirebaseUser user = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  return user.uid;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("User sign out");
}

void signOut() async {
  await _auth.signOut();
}

Future<String> organisationSignup() async {
  const url = 'https://www.facebook.com/';
  if (await canLaunch(url)) {
    await launch(url);
    return "Loaded";
  } else
    return 'Could not load $url';
}
