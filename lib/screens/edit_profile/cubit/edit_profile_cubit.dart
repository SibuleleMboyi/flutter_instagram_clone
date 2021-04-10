import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/profile/bloc/profile_bloc.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

/* Dependencies that are needed on the Edit Profile are : -
  1) UserRepository to update bio, username,
  2) StorageRepository  to update the User's profile Image
  3) ProfileBloc in order to refresh the user's profile by adding the event 'ProfileLoadUser' to the ProfileBloc.
  (if we don't have 'ProfileBloc', we won't be able to add the event 'ProfileLoadUser', so once the user presses the 'update button'
    they will navigate back to the previous screen and the no UI update will occur
  )
 */
class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final ProfileBloc _profileBloc;


  EditProfileCubit({
    @required UserRepository userRepository,
    @required StorageRepository storageRepository,
    @required ProfileBloc profileBloc
  })
      : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    //we want the bio and the username to be already updated on the 'Edit Profile Screen' when we tap 'Edit Profile' button.
    final user = _profileBloc.state.user;
    emit(state.copyWith(username: user.username, bio: user.bio));
  }

  void profileImageChanged(File image) {
    emit(
        state.copyWith(profileImage: image, status: EditProfileStatus.initial));
  }

  void usernameChanged(String username) {
    emit(state.copyWith(username: username, status: EditProfileStatus.initial));
  }

  void bioChanged(String bio) {
    emit(state.copyWith(bio: bio, status: EditProfileStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      /// old user's information
      final user = _profileBloc.state.user;
      var profileImageUrl = user.profileImageUrl;

      if (state.profileImage != null) {
        profileImageUrl = await _storageRepository.uploadProfileImage(
          url: profileImageUrl,
          image: state.profileImage,
        );
      }

      final updatedUser = user.copyWith(
        username: state.username,
        bio: state.bio,
        profileImageUrl: profileImageUrl,
      );

      /// updates the User in Firebase fireStore
      await _userRepository.updateUser(user: updatedUser);

      /// to update the  UI with the latest user's information
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
                message: 'We are unable to update your profile')),
      );
    }
  }
}
