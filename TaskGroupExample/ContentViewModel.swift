//
//  ContentViewModel.swift
//  TaskGroupExample
//
//  Created by iOS신상우 on 4/9/24.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var text = "-"
    
    @MainActor
    @Published var isLoading = false
    
    func getData() {
        Task {
            // of: 하위 테스크들의 리턴타입으로 동일한 타입을 반환해야함
            // returning: 그룹테스크의 리턴타입 -> 하위테스크의 결과로 새로운 타입을 만들어 리턴도 가능함 기본값을 사용하면 하위테스크타입의 배열로 반환
            // body: 클로저의 인자로 들어오는 groupTask인스턴스를 외부에서 사용하지 말라고 공식문서에 적혀있음 클로저 내부에서만 사용할것
            // 모든 하위 테스크들은 병렬적으로 수행되나 순서는 보장되지 않음. 이 예제를 실행해보면 호출시마다 결과의 순서가 다른것을 볼 수 있음
            // 하위 테스크들의 타입이 다른 경우엔 async let을 이용하거나 enum등의 공통타입으로 묶어서 사용할 수 있음
            // async let과 달리 런타임에 하위테스크 개수를 정할 수 있음 보다 유연하나 비교적 안전성은 낮을 수 있음
            
            let result = await withTaskGroup(of: String.self, returning: String.self, body: { @MainActor group in
                isLoading = true
                var result: String = ""
                
                group.addTask {
                    do {
                        let post = try await NetworkService.shared.getPosts(id: 12)
                        return post
                    } catch {
                        print(error)
                        return "-"
                    }
                }
                
                group.addTask {
                    do {
                        let todo = try await NetworkService.shared.getTodos(id: 14)
                        return todo
                    } catch {
                        print(error)
                        return "-"
                    }
                }
                
                
                while let taskResult = await group.next() {
                    result.append(taskResult)
                    result.append("\n\n")
                }
                
                return result
            })
            
            DispatchQueue.main.async {
                self.text = result
                self.isLoading = false
            }
        }
    }
}

extension ContentViewModel {

    func getDataWithThrow() {
        // throw 하나로 묶어서 catch 가능
        Task {
            do {
                let result = try await withThrowingTaskGroup(of: String.self, returning: String.self, body: { @MainActor group in
                    isLoading = true
                    var result: String = ""
                    
                    group.addTask {
                        let post = try await NetworkService.shared.getPosts(id: 12)
                        return post
                    }
                    
                    group.addTask {
                        let todo = try await NetworkService.shared.getTodos(id: 14)
                        return todo
                    }
                    
                     while let taskResult = try await group.next() {
                        result.append(taskResult)
                        result.append("\n\n")
                    }
                    
                    return result
                })
                
                DispatchQueue.main.async {
                    self.text = result
                    self.isLoading = false
                }
            } catch {
                print(error)
            }
        }
    }
}


extension ContentViewModel {
    // 하위테스크의 리턴값을 사용하지 않을때 사용 하위테스크로 인한 사이드 이펙트를 없앨 수 있음
    func saveDataWithDiscardTaskGroup() {
        Task {
            await withDiscardingTaskGroup(returning: Void.self, body: { @MainActor group in
                isLoading = true
                
                // 하위 테스크의 리턴 x -> 가져오는 것보단 저장하는 로직에 유용
                group.addTask {
                    do {
                        let post = try await NetworkService.shared.getPosts(id: 12)
                        // TODO: Save
                        print(post)
                    } catch {
                        print(error)
                    }
                }
                
                // 하위 테스크의 리턴 x -> 가져오는 것보단 저장하는 로직에 유용
                group.addTask {
                    do {
                        let todo = try await NetworkService.shared.getTodos(id: 14)
                        // TODO: Save
                        print(todo)
                    } catch {
                        print(error)
                    }
                }
            })
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
