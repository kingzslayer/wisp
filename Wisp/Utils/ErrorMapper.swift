import Foundation
import Supabase

enum ErrorMapper {
    static func message(for error: Error) -> String {
        if let error = error as? URLError { return message(for: error) }
        if let error = error as? AuthError { return message(for: error) }
        if let error = error as? BondError { return message(for: error) }
        if let urlError = extractURLError(from: error) { return message(for: urlError) }
        return "hmm, that didn't work"
    }

    private static func message(for error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut,
             .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed,
             .secureConnectionFailed:
            return "no connection"
        default:
            return "hmm, that didn't work"
        }
    }

    private static func message(for error: AuthError) -> String {
        switch error {
        case .api(_, let code, _, _):
            switch code {
            case .overRequestRateLimit, .overEmailSendRateLimit, .overSMSSendRateLimit:
                return "too many attempts. wait a moment"
            case .otpExpired:
                return "code expired. send a new one"
            case .invalidCredentials:
                return "that's not it. check your email"
            case .userNotFound:
                return "couldn't find that account"
            default:
                return "hmm, that didn't work"
            }
        case .sessionMissing:
            return "something went wrong. try again"
        default:
            return "hmm, that didn't work"
        }
    }

    private static func message(for error: BondError) -> String {
        switch error {
        case .threadNotFound:
            return "that thread echoes into silence"
        case .cannotBondWithSelf:
            return "you can't whisper to your own shadow"
        case .alreadyBonded:
            return "your souls already hum together"
        case .alreadyReaching:
            return "your whisper still lingers there"
        }
    }

    private static func extractURLError(from error: Error) -> URLError? {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return URLError(URLError.Code(rawValue: nsError.code))
        }
        for underlying in nsError.underlyingErrors {
            if let urlError = underlying as? URLError { return urlError }
            if let found = extractURLError(from: underlying) { return found }
        }
        return nil
    }
}
