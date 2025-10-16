import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/balance_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/recipient_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/saving_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/user_model.dart';
import 'package:my_super_exchange_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:my_super_exchange_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'package:oxidized/oxidized.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late HomeRepository mockRepository;
  late HomeBloc homeBloc;

  const mockUser = UserModel(
    name: 'John Doe',
    firstName: 'John',
    profileImage: 'profile.jpg',
    notificationCount: 5,
  );

  const mockBalance = BalanceModel(
    amount: 1500.50,
    currency: 'USD',
  );

  final mockRecipients = [
    const RecipientModel(
      id: '1',
      name: 'Alice',
      image: 'alice.jpg',
    ),
    const RecipientModel(
      id: '2',
      name: 'Bob',
      image: 'bob.jpg',
    ),
  ];

  final mockSavings = [
    const SavingModel(
      id: '1',
      name: 'Vacation',
      amount: 500,
      target: 1000,
      color: 0xFF4CAF50,
    ),
    const SavingModel(
      id: '2',
      name: 'Emergency Fund',
      amount: 2000,
      target: 5000,
      color: 0xFF2196F3,
    ),
  ];

  final mockHomeData = {
    'user': mockUser,
    'balance': mockBalance,
    'recentRecipients': mockRecipients,
    'savings': mockSavings,
  };

  setUp(() {
    mockRepository = MockHomeRepository();
    homeBloc = HomeBloc(homeRepository: mockRepository);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc', () {
    test('initial state is HomeInitial', () {
      expect(homeBloc.state, isA<HomeInitial>());
    });

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeDataLoadedState] when HomeInitialEvent succeeds',
      build: () {
        when(() => mockRepository.getHomeData()).thenAnswer(
          (_) async => Result.ok(mockHomeData),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeInitialEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeDataLoadedState>()
            .having((state) => state.user.name, 'user name', 'John Doe')
            .having((state) => state.balance.amount, 'balance amount', 1500.50)
            .having((state) => state.recipients.length, 'recipients length', 2)
            .having((state) => state.savings.length, 'savings length', 2),
      ],
      verify: (_) {
        verify(() => mockRepository.getHomeData()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeEmptyDataState] when user name is empty',
      build: () {
        final emptyUserData = {
          'user': const UserModel(
            name: '',
            firstName: '',
            profileImage: '',
            notificationCount: 0,
          ),
          'balance': mockBalance,
          'recentRecipients': mockRecipients,
          'savings': mockSavings,
        };
        when(() => mockRepository.getHomeData()).thenAnswer(
          (_) async => Result.ok(emptyUserData),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeInitialEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeEmptyDataState>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoadingState, HomeErrorState] when HomeInitialEvent fails',
      build: () {
        when(() => mockRepository.getHomeData()).thenAnswer(
          (_) async => const Result.err('Error al cargar datos'),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeInitialEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeErrorState>().having(
          (state) => state.error,
          'error message',
          'Error al cargar datos',
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeDataLoadedState] when HomeLoadDataEvent succeeds',
      build: () {
        when(() => mockRepository.getHomeData()).thenAnswer(
          (_) async => Result.ok(mockHomeData),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadDataEvent()),
      expect: () => [
        isA<HomeDataLoadedState>()
            .having((state) => state.user.name, 'user name', 'John Doe')
            .having((state) => state.balance.currency, 'balance currency', 'USD')
            .having((state) => state.recipients.first.name, 'first recipient', 'Alice')
            .having((state) => state.savings.first.name, 'first saving', 'Vacation'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeEmptyDataState] when HomeLoadDataEvent returns empty user',
      build: () {
        final emptyUserData = {
          'user': const UserModel(
            name: '',
            firstName: '',
            profileImage: '',
            notificationCount: 0,
          ),
          'balance': mockBalance,
          'recentRecipients': mockRecipients,
          'savings': mockSavings,
        };
        when(() => mockRepository.getHomeData()).thenAnswer(
          (_) async => Result.ok(emptyUserData),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadDataEvent()),
      expect: () => [
        isA<HomeEmptyDataState>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeErrorState] when HomeLoadDataEvent fails',
      build: () {
        when(() => mockRepository.getHomeData()).thenAnswer(
          (_) async => const Result.err('Network error'),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadDataEvent()),
      expect: () => [
        isA<HomeErrorState>().having(
          (state) => state.error,
          'error message',
          'Network error',
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'handles exception in HomeLoadDataEvent',
      build: () {
        when(() => mockRepository.getHomeData()).thenThrow(
          Exception('Unexpected error'),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadDataEvent()),
      expect: () => [
        isA<HomeErrorState>().having(
          (state) => state.error,
          'error message',
          contains('Exception'),
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits correct data with empty recipients and savings',
      build: () {
        final dataWithEmptyLists = {
          'user': mockUser,
          'balance': mockBalance,
          'recentRecipients': <RecipientModel>[],
          'savings': <SavingModel>[],
        };
        when(() => mockRepository.getHomeData()).thenAnswer(
          (_) async => Result.ok(dataWithEmptyLists),
        );
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeInitialEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeDataLoadedState>()
            .having((state) => state.recipients.length, 'recipients length', 0)
            .having((state) => state.savings.length, 'savings length', 0),
      ],
    );
  });
}

