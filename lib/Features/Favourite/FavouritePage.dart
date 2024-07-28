import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    context.read<MoodCubit>().loadMood();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.backGround,
      appBar: _buildAppBar(),
      body: BlocBuilder<MoodCubit, MoodState>(
        builder: (context, state) {
          if (state is GetMoodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetMoodSuccess) {
            return _buildFavoriteDiariesGrid(state.moods);
          } else {
            return const Center(
                child: Text('Failed to load favorite diaries.'));
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: ColorsApp.backGround,
      backgroundColor: ColorsApp.backGround,
      shadowColor: ColorsApp.mediumGrey,
      elevation: 1,
      toolbarHeight: 100,
      centerTitle: true,
      title: Image.asset(
        "assets/images/Tasks.png",
        scale: 25,
      ),
    );
  }

  Widget _buildFavoriteDiariesGrid(List<MoodModel> moods) {
    final favoriteDiaries =
        moods.where((mood) => mood.favorite).toList().reversed.toList();

    if (favoriteDiaries.isEmpty) {
      return const Center(child: Text('No favorite diaries yet!'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: favoriteDiaries.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        final diary = favoriteDiaries[index];
        return Card(
          child: ListTile(
            title: Text(diary.label),
            subtitle: Text(diary.location),
            trailing: IconButton(
              icon: Icon(
                diary.favorite ? Icons.favorite : Icons.favorite_border,
                color: diary.favorite ? Colors.red : null,
              ),
              onPressed: () {
                context.read<MoodCubit>().toggleFavorite(diary.id!);
              },
            ),
            onTap: () {
              // Navigate to the detailed view of the diary entry
            },
          ),
        );
      },
    );
  }
}
