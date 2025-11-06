// GlobalStore.ts
export default class GlobalStore {
  private static _sessionId: string = '';

  static get sessionId(): string {
    return this._sessionId;
  }

  static set sessionId(value: string) {
    this._sessionId = value;
  }
}
