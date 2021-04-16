const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp();

exports.onFollowUser = functions.firestore.document('/followers/{userId}/userFollowers/{followerId}')
    .onCreate(async (_, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        // Increment followed user's followers count.
        const followedUserRef = admin.firestore().collection('users').doc(userId);
        const followedUserDoc = await followedUserRef.get();

        if(followedUserDoc.get('followers') !== undefined){  // check if the 'followers' field is present
           await followedUserRef.update({
                followers: followedUserDoc.get('followers') + 1,
            });
        } else{
            await followedUserRef.update({followers: 1});
        }

        // Increment user's following count.
        const userRef = admin.firestore().collection('users').doc(followerId);
        const userDoc = await userRef.get();

        if(userDoc.get('following') !== undefined){  // check if the 'followers' field is present
            await userRef.update({following: userDoc.get('following') + 1});
        } else{
            await userRef.update({following: 1});
        }

        // Add followed user's posts to the following user's post feed
        const followedUserPostsRef = admin.firestore().collection('posts')
            .where('author', '==', followedUserRef);

        const userFeedRef = admin.firestore().collection('feeds')
            .doc(followerId)
            .collection('userFeed')

        const followedUserPostsSnapshot = await followedUserPostsRef.get();
        followedUserPostsSnapshot.forEach((doc) =>{
           if(doc.exists){
               userFeedRef.doc(doc.id).set(doc.data());
           }
        });
    });

exports.onUnfollowUser = functions.firestore.document('/followers/{userId}/userFollowers/{followerId}')
    .onDelete(async (_, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        // Decrement unfollowed user's followers count.
        const followedUserRef = admin.firestore().collection('users').doc(userId);
        const followedUserDoc = await followedUserRef.get();

        if(followedUserDoc.get('followers') !== undefined){  // check if the 'followers' field is present
            await followedUserRef.update({
                followers: followedUserDoc.get('followers') - 1,
            });
        } else{
            await followedUserRef.update({followers: 0});
        }

        // Decrement user's following count.
        const userRef = admin.firestore().collection('users').doc(followerId);
        const userDoc = await userRef.get();

        if(userDoc.get('following') !== undefined){  // check if the 'followers' field is present
            await userRef.update({
                following: userDoc.get('following') - 1,
            });
        } else{
            await userRef.update({following: 0});
        }

        // Remove unfollowed user's posts from user's post feed
        const userFeedRef = admin.firestore().collection('feeds').doc(followerId)
            .collection('userFeed').where('author', '==', followedUserRef)

        const userPostsSnapshot = await userFeedRef.get();
        userPostsSnapshot.forEach((doc) => {
            if(doc.exists){
                doc.ref.delete();
            }
        });
    });


exports.onCreatePost = functions.firestore.document('/posts/{postId}')
    .onCreate(async (snapshot, context) =>{
        const postId = context.params.postId;

        //Get author id from the author field in the post document on firebase.
        const authorRef = snapshot.get('author');
        const authorId = authorRef.path.split('/')[1];

        // Add new post to feeds of all followers.
        const userFollowersRef = admin.firestore().collection('followers')
            .doc(authorId).collection('userFollowers');

        const userFollowersSnapshot = await userFollowersRef.get();
        userFollowersSnapshot.forEach((doc) =>{
            admin.firestore().collection('feeds')
                .doc(doc.id).collection('userFeed')
                .doc(postId).set(snapshot.data());
        });

    });

exports.onUpdatePost = functions.firestore.document('/posts/{postId}')
    .onUpdate(async (snapshot, context) => {
        const postId = context.params.postId;

        //Get author id from the author field in the post document on firebase.
        const authorRef = snapshot.after.get('author');
        const authorId = authorRef.path.split('/')[1];

        // Update post data in each follower's feed
        const updatedPostData = snapshot.after.data(); // gives us updated snapshot
        const userFollowersRef = admin.firestore().collection('followers')
            .doc(authorId).collection('userFollowers');

        const userFollowersSnapshot = await userFollowersRef.get();
        userFollowersSnapshot.forEach(async (doc) =>{
            const postRef = admin.firestore().collection('feeds')
                .doc(doc.id).collection('userFeed');
            const postDoc = await postRef.doc(postId).get();
            if(postDoc.exists){
                postDoc.ref.update(updatedPostData);
            }
        });
    });




